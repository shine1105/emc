module.exports = {
  apps: [
    {
      name: "EMC-api",
      script: "bun",
      args: ["run", "src/index.ts"],
      interpreter: "none",
      watch: true,
      autorestart: true,
      restart_delay: 1000,
      cron_restart: "*/5 * * * * ",
      exec_mode: "fork",
      env: { NODE_ENV: "development" },
      env_production: { NODE_ENV: "production" },
    
    },
  ],
};