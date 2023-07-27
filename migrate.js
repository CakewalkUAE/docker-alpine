const { execute } = require("@getvim/execute");
let migrateUrl = process.env.migrateUrl;
const takeDBBackUp = () => {
  execute(migrateUrl)
    .then((res) => {
      console.log(res);
      console.log("DB Backup taken successfully");
    })
    .catch((err) => {
      console.log(err);
    });
};

takeDBBackUp();
