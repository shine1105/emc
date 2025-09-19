import pm2 from 'pm2';

const APP_NAME = 'EMC-api';

pm2.connect((err) => {
  if (err) {
    console.error('PM2 connect error:', err);
    process.exit(2);
  }

  pm2.describe(APP_NAME, (err, processDescription) => {
    if (err) {
      console.error(`Failed to describe ${APP_NAME}:`, err);
      pm2.disconnect();
      return;
    }

    const startApp = () => {
      pm2.start({
        name: APP_NAME,
        script: 'bun',
        args: ['run', 'src/index.ts'],
        interpreter: 'none',
        exec_mode: 'fork',
        watch: false,
        autorestart: true,
        restart_delay: 1000,
      }, (err) => {
        if (err) {
          console.error(`Failed to start ${APP_NAME}:`, err);
        } else {
          console.log(`${APP_NAME} started with Bun using PM2`);
        }

//         pm2.launchBus((err, bus) => {
//         if (err || !bus) {
//         console.error('Failed to launch PM2 bus:', err);
//         return;
//       }

//         bus.on(`${APP_NAME}:msg`, function (packet) {
//        console.log('Message from app:', packet);
//   });
// });
        pm2.disconnect();
      });
    };

    if (processDescription.length === 0) {
      console.log(`${APP_NAME} is not running, starting it now..`);
      startApp();
    } else {
      console.log(`${APP_NAME} is already running, stopping it first..`);
      pm2.stop(APP_NAME, (err) => {
        if (err) {
          console.error(`Failed to stop ${APP_NAME}:`, err);
          pm2.disconnect();
        } else {
          console.log(`${APP_NAME} stopped successfully`);
          startApp();
        }
      });
    }
  });
});
