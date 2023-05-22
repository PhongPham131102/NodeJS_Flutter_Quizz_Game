const express = require("express");
const router = express.Router();
const {getProfile,updategender,updatename,addgold} = require("../controllers/userProfileController");
const validateToken = require("../middleware/validateTokenHandler");
router.get("/getprofile", validateToken, getProfile);
router.post("/updategender",validateToken,updategender);
router.post("/updatename",validateToken,updatename);
router.post("/addgold",validateToken,addgold);
module.exports = router;
