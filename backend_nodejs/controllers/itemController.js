const Item = require("../models/itemModel");
const asyncHandler = require("express-async-handler");

const create = asyncHandler(async (req, res) => {
  const {
    name,
    shortName,
    type,
    detailType,
    gender,
    typeMoney,
    price,
    quantityPurchasable,
    buyAble,
  } = req.body;
  const item = await Item.create({
    name,
    shortName,
    type,
    detailType,
    gender,
    typeMoney,
    price,
    quantityPurchasable,
    buyAble,
  });

  if (item) {
    res.status(201).json({
      success: true,
      message: "vật phẩm đã được tạo thành công",
      data: item,
    });
  } else {
    res.status(400).json({
      success: false,
      message: "Không thể tạo vật phẩm",
    });
  }
});

const createmutiple = asyncHandler(async (req, res) => {
  const items = req.body;

  // Mảng để lưu các câu hỏi đã được tạo thành công
  const createdItems = [];

  // Lặp qua từng câu hỏi trong mảng
  for (let i = 0; i < items.length; i++) {
    const {
      name,
      shortName,
      type,
      detailType,
      gender,
      typeMoney,
      price,
      quantityPurchasable,
      buyAble,
    } = items[i];

    // Tạo một câu hỏi mới dựa trên dữ liệu từ mảng câu hỏi
    const item = await Item.create({
      name,
      shortName,
      type,
      detailType,
      gender,
      typeMoney,
      price,
      quantityPurchasable,
      buyAble,
    });

    if (item) {
      createdItems.push(item);
    }
  }

  if (createdItems.length > 0) {
    res.status(201).json({
      success: true,
      message: "Các vật phẩm đã được tạo thành công",
      data: createdItems,
    });
  } else {
    res.status(400).json({
      success: false,
      message: "Không thể tạo vật phẩm",
    });
  }
});
// const getall = asyncHandler(async (req, res) => {
//   res.status(200).json({
//     message: await Question.find({ typeLanguage: "c++" }).limit(5),
//   });
// });
module.exports = {
  create,
  createmutiple,
  //   getall,
};
