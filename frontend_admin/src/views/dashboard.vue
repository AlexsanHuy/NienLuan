<template>
  <div class="container mt-4">
    <h1 class="mb-4 text-primary fw-bold">📊 Dashboard</h1>
    <div class="row">
      <div class="col-md-4">
        <div class="card text-white bg-primary mb-3 shadow">
          <div class="card-header fw-bold">📦 Số đơn hàng</div>
          <div class="card-body text-center">
            <h3 class="card-title">{{ totalOrders }}</h3>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card text-white bg-success mb-3 shadow">
          <div class="card-header fw-bold">💰 Doanh thu</div>
          <div class="card-body text-center">
            <h3 class="card-title">{{ formatPrice(totalRevenue) }}</h3>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card text-white bg-danger mb-3 shadow">
          <div class="card-header fw-bold">📦 Số lượng món ăn</div>
          <div class="card-body text-center">
            <h3 class="card-title">{{ totalProducts }}</h3>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import axios from "axios";

const totalOrders = ref(0);
const totalRevenue = ref(0);
const totalProducts = ref(0);

const API_ORDERS = "http://localhost:5000/api/orders";
const API_PRODUCTS = "http://localhost:5000/api/products";

onMounted(async () => {
  await fetchTotalOrders();
  await fetchTotalRevenue();
  await fetchTotalProducts();
});

const fetchTotalOrders = async () => {
  try {
    const response = await axios.get(API_ORDERS);
    totalOrders.value = response.data.length;
  } catch (error) {
    console.error("Lỗi khi lấy số đơn hàng:", error);
  }
};

const fetchTotalRevenue = async () => {
  try {
    const response = await axios.get(API_ORDERS);
    totalRevenue.value = response.data.reduce(
      (acc, order) => acc + order.total,
      0
    );
  } catch (error) {
    console.error("Lỗi khi tính tổng doanh thu:", error);
  }
};

const fetchTotalProducts = async () => {
  try {
    const response = await axios.get(API_PRODUCTS);
    totalProducts.value = response.data.length;
  } catch (error) {
    console.error("Lỗi khi lấy số lượng sản phẩm:", error);
  }
};

const formatPrice = (price) => {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
  }).format(price);
};
</script>
