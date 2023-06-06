const UserProfile = require("../models/userProfileModel");
const UsersItem = require("../models/userItemModel");
const asyncHandler = require("express-async-handler");
const getProfile = asyncHandler(async (req, res) => {
  console.log(req.user.id);
  let profile = await UserProfile.findOne({ uid: req.user.id });
  if (profile) {
    console.log("get");
    res.status(200).json({ profile: profile });
  } else {
    console.log("create");
    profile = await UserProfile.create({
      uid: req.user.id,
    });
    res.status(200).json({ profile: profile });
  }
});
const queryIdProfile = asyncHandler(async (req, res) => {
  let profile = await UserProfile.findOne({ uid: req.body.uid });
  res.status(200).json({ profile: profile });
});
const updategender = asyncHandler(async (req, res) => {
  let profile = await UserProfile.findOne({ uid: req.user.id });
  profile.gender = req.body.gender;
  await profile.save();
  if (profile.gender == "") {
    res.status(400).send();
  } else {
    if (req.body.gender == "male") {
      profile.shirt = "caothang";
      profile.trouser = "lightbluetrouser";
      profile.shoe = "greyshoes";
      profile.bag = "bluebag";
      //tạo áo mặc định
      await UsersItem.create({
        idItem: "caothang",
        uid: req.user.id,
        quantity: 1,
      });
      //tạo quần mặc định
      await UsersItem.create({
        idItem: "lightbluetrouser",
        uid: req.user.id,
        quantity: 1,
      }); //tạo giày mặc định
      await UsersItem.create({
        idItem: "greyshoes",
        uid: req.user.id,
        quantity: 1,
      });
      //tạo cặp mặc định
      await UsersItem.create({
        idItem: "bluebag",
        uid: req.user.id,
        quantity: 1,
      });
    } else {
      profile.shirt = "caothang";
      profile.trouser = "lightblueskirt";
      profile.shoe = "pinkshoes";
      profile.bag = "bluebag"; //tạo áo mặc định
      await UsersItem.create({
        idItem: "caothang",
        uid: req.user.id,
        quantity: 1,
      });
      //tạo quần mặc định
      await UsersItem.create({
        idItem: "lightblueskirt",
        uid: req.user.id,
        quantity: 1,
      }); //tạo giày mặc định
      await UsersItem.create({
        idItem: "pinkshoes",
        uid: req.user.id,
        quantity: 1,
      });
      //tạo cặp mặc định
      await UsersItem.create({
        idItem: "bluebag",
        uid: req.user.id,
        quantity: 1,
      });
    }
    profile.save();
    res.status(201).send();
  }
});
const updatename = asyncHandler(async (req, res) => {
  let profile = await UserProfile.findOne({ uid: req.user.id });
  profile.name = req.body.name;
  await profile.save();
  if (profile.name == "") {
    res.status(400).send();
  } else {
    res.status(201).send();
  }
});
const addgold = asyncHandler(async (req, res) => {
  let profile = await UserProfile.findOne({ uid: req.user.id });
  profile.gold += req.body.gold;
  profile.diamond += req.body.diamond;
  await profile.save();
  console.log(`profile${profile.uid}`);
  req.io.emit(`profile${profile.uid}`, { profile: profile });
  res.send();
});
const changeClothes = asyncHandler(async (req, res) => {
  console.log(req.body.type, req.body.value);
  let profile = await UserProfile.findOne({ uid: req.user.id });
  if (req.body.type == "Áo") {
    profile.shirt = req.body.value;
    await profile.save();
    req.io.emit(`profile${profile.uid}`, { profile: profile });
    res.status(200).send();
  }
  if (req.body.type == "Quần" || req.body.type == "Váy") {
    profile.trouser = req.body.value;
    await profile.save();
    req.io.emit(`profile${profile.uid}`, { profile: profile });
    res.status(200).send();
  }
  if (req.body.type == "Giày") {
    profile.shoe = req.body.value;
    await profile.save();
    req.io.emit(`profile${profile.uid}`, { profile: profile });
    res.status(200).send();
  }
  if (req.body.type == "Cặp") {
    profile.bag = req.body.value;
    await profile.save();
    req.io.emit(`profile${profile.uid}`, { profile: profile });
    res.status(200).send();
  }
});
const changename = asyncHandler(async (req, res) => {
  let profile = await UserProfile.findOne({ uid: req.user.id });
  profile.name = req.body.name;
  await profile.save();
  req.io.emit(`profile${profile.uid}`, { profile: profile });
  let userItem = await UsersItem.findOne({
    idItem: req.body.idItem,
    uid: req.user.id,
  });
  if (userItem.quantity == 1) {
    await UsersItem.deleteOne({ _id: userItem._id });
  } else {
    userItem.quantity -= 1;
    await userItem.save();
  }
  res.status(200).send();
});
module.exports = {
  getProfile,
  updategender,
  updatename,
  addgold,
  changeClothes,
  changename,
  queryIdProfile,
};
