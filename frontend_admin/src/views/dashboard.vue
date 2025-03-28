<template>
  <div class="container mt-4">
    <h1 class="mb-4">📊 Dashboard</h1>

    <div class="row">
      <div class="col-md-4">
        <div class="card text-white bg-primary mb-3 shadow-lg">
          <div class="card-header fw-bold text-center">📦 Số đơn hàng</div>
          <div class="card-body text-center">
            <h3 class="card-title">{{ totalOrders }}</h3>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card text-white bg-success mb-3 shadow-lg">
          <div class="card-header fw-bold text-center">💰 Doanh thu</div>
          <div class="card-body text-center">
            <h3 class="card-title">{{ formatPrice(totalRevenue) }}</h3>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card text-white bg-danger mb-3 shadow-lg">
          <div class="card-header fw-bold text-center">🍽️ Số lượng món ăn</div>
          <div class="card-body text-center">
            <h3 class="card-title">{{ totalProducts }}</h3>
          </div>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-md-6">
        <div class="card mb-3 shadow-lg">
          <div class="card-header fw-bold text-center bg-light text-dark">
            📈 Doanh thu theo tháng
          </div>
          <div class="card-body">
            <canvas ref="revenueChart"></canvas>
          </div>
        </div>
        <div class="card mb-3 shadow-lg">
          <div class="card-header fw-bold text-center bg-light text-dark">
            📈 Số đơn hàng theo tháng
          </div>
          <div class="card-body">
            <canvas ref="orderChart"></canvas>
          </div>
        </div>
      </div>

      <div class="col-md-6">
        <div class="card mb-3 shadow-lg">
          <div class="card-header fw-bold text-success text-center bg-light">
            🔥 Sản phẩm bán chạy
          </div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-bordered table-hover">
                <thead class="table-dark text-center">
                  <tr>
                    <th>#</th>
                    <th>Tên sản phẩm</th>
                    <th class="text-center">Số lượng bán</th>
                  </tr>
                </thead>
                <tbody>
                  <tr
                    v-for="(product, index) in bestSellingProducts"
                    :key="product.id"
                  >
                    <td class="text-center">{{ index + 1 }}</td>
                    <td>{{ product.name }}</td>
                    <td class="text-center fw-bold text-primary">
                      {{ product.totalQuantity }}
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { Chart } from "chart.js/auto";
import axios from "axios";

const API_ORDERS = "http://localhost:5000/api/orders";
const API_PRODUCTS = "http://localhost:5000/api/products";

const totalOrders = ref();
const totalRevenue = ref();
const totalProducts = ref();
const bestSellingProducts = ref([]);
const revenueChart = ref(null);
const orderChart = ref(null);

onMounted(() => {
  drawRevenueChart();
  fetchTotalOrders();
  fetchTotalRevenue();
  fetchTotalProducts();
  fetchBestSellingProducts();
  drawOrderChart();
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

const fetchBestSellingProducts = async () => {
  try {
    const response = await axios.get(API_ORDERS + "/count/quantity");
    bestSellingProducts.value = response.data;
  } catch (error) {
    console.error("Lỗi khi lấy sản phẩm bán chạy:", error);
  }
};

const drawRevenueChart = () => {
  const months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  const revenues = [
    3000000, 4500000, 5000000, 7000000, 8000000, 6500000, 9000000, 8500000,
    7500000, 9500000, 10500000, 12000000,
  ];

  if (revenueChart.value) {
    new Chart(revenueChart.value, {
      type: "line",
      data: {
        labels: months,
        datasets: [
          {
            label: "Doanh thu",
            data: revenues,
            borderColor: "#28a745",
            backgroundColor: "rgba(40, 167, 69, 0.2)",
            borderWidth: 2,
            fill: true,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: true,
            position: "top",
          },
        },
        scales: {
          x: { title: { display: true, text: "Tháng" } },
          y: { title: { display: true, text: "Doanh thu (VND)" } },
        },
      },
    });
  }
};

const formatPrice = (price) => {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
  }).format(price);
};

const drawOrderChart = () => {
  const months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  const orders = [100, 80, 90, 120, 150, 140, 80, 100, 120, 150, 140, 80];

  if (orderChart.value) {
    new Chart(orderChart.value, {
      type: "line",
      data: {
        labels: months,
        datasets: [
          {
            label: "Số đơn hàng",
            data: orders,
            borderColor: "#007bff",
            backgroundColor: "rgba(0, 123, 255, 0.2)",
            borderWidth: 2,
            fill: true,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: true,
            position: "top",
          },
        },
        scales: {
          x: { title: { display: true, text: "Tháng" } },
          y: {
            title: { display: true, text: "Số đơn hàng" },
            beginAtZero: true,
          },
        },
      },
    });
  }
};
</script>

<style>
.card {
  border-radius: 12px;
  transition: transform 0.3s ease-in-out;
}

.card:hover {
  transform: scale(1.05);
}
</style>
