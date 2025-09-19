import pm2 from 'pm2';

const APP_NAME = 'EMC-api'; 

pm2.connect((err) => {
  if (err) {
    console.error('Failed to connect to PM2:', err);
    process.exit(2);
  }

  pm2.list((err, list) => {
    if (err) {
      console.error('Failed to list PM2 processes:', err);
      pm2.disconnect();
      return;
    }

    const target = list.find((proc) => proc.name === APP_NAME);

    if (!target) {
      console.error(`No process found with name: ${APP_NAME}`);
      pm2.disconnect();
      return;
    }

    pm2.sendDataToProcessId(
      target.pm_id!,
      {
        type: 'process:msg',
        data: { some: 'data from controller' },
        topic: 'api ',
      },
      (err, res) => {
        if (err) {
          console.error('Failed to send data:', err);
        } else {
          console.log(' Message sent:', res);
        }

      pm2.launchBus((err, bus) => {
        if (err || !bus) {
          console.error('PM2 bus error:', err);
          return;
        }

        bus.on('process:msg', (packet) => {
          console.log(' Message received on PM2 bus:', packet);
        });
      });

    });
  });
});
