const { Router } = require("express")

const editRouter = Router();

const editControllers = require("../controllers/edits");


editRouter.post(
  "/save-my-page",
  editControllers.createEdit
);

editRouter.get(
  "edits",
  editControllers.getAllEdits
)



module.exports = editRouter;