const Edit = require("../models/edits");

const createEdit = async (req, res) => {
  const {
    editContent
  } = req.body;

  console.log(req.body)

  try {
    const newEdit = new Edit({
      editContent
    });

    const edit = await newEdit.save();
    res.json(edit);
  } catch (err) {
    console.log(err.message);

    return res.status(500).send("Server Error");
  }
};

const getAllEdits = async(req, res) => {
  try {
    console.log(res);
    const edits = await Edit.find().sort({
      date: -1,
    })

    res.json(edits)
  } catch (err) {
    console.log(err.message);

    return res.status(500).send("Server Error");
  }
};


module.exports = {
  createEdit,
  getAllEdits
}