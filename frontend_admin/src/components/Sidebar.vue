<template>
  <div class="sidebar bg-dark text-white d-flex flex-column p-3">
    <h4 class="text-center fw-bold">ADMIN PANEL</h4>
    <hr />
    <ul class="nav flex-column">
      <li class="nav-item">
        <RouterLink to="/" class="nav-link">
          <i class="fa fa-chart-line"></i> Thống kê
        </RouterLink>
      </li>
      <li>
        <RouterLink to="/categories" class="nav-link">
          <i class="fa fa-list"></i> Loại món ăn
        </RouterLink>
      </li>
      <li>
        <RouterLink to="/products" class="nav-link">
          <i class="fa fa-utensils"></i> Món ăn
        </RouterLink>
      </li>
      <li>
        <RouterLink to="/accounts" class="nav-link">
          <i class="fa fa-user"></i> Tài khoản
        </RouterLink>
      </li>
      <li>
        <RouterLink to="/orders" class="nav-link">
          <i class="fa fa-shopping-cart"></i> Đơn hàng
        </RouterLink>
      </li>
      <li>
        <RouterLink to="/discount" class="nav-link">
          <i class="fa fa-percent"></i> Khuyến mãi
        </RouterLink>
      </li>
    </ul>
    <hr />
    <div class="text-center">
      <h5>Xin chào!</h5>
    </div>
  </div>
</template>

<script setup>
import { RouterLink } from "vue-router";
</script>

<style scoped>
.sidebar {
  width: 250px;
  height: 100vh;
}
.nav-link {
  color: white;
  padding: 12px;
  border-radius: 8px;
  font-size: 1.1rem;
  display: flex;
  align-items: center;
  gap: 10px;
}
.nav-link:hover {
  background-color: #198754;
  color: white;
}
.nav-link i {
  font-size: 1.2rem;
}
</style>
