<template>
  <div class="container mt-4">
    <h1 class="mb-4">📦 Quản lý đơn hàng</h1>

    <div class="input-group mb-3">
      <input
        v-model="searchQuery"
        type="text"
        class="form-control"
        placeholder="🔍 Tìm kiếm đơn hàng..."
      />
    </div>

    <table class="table table-bordered table-striped text-center align-middle">
      <thead class="table-dark">
        <tr>
          <th>#</th>
          <th>Khách hàng</th>
          <th>Trạng thái</th>
          <th>Địa chỉ</th>
          <th>Phương thức</th>
          <th>Tổng tiền</th>
          <th>Ngày tạo</th>
          <th>Hành động</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(order, index) in filteredOrders" :key="order.id">
          <td>{{ index + 1 }}</td>
          <td>{{ getUserName(order.uid) }}</td>
          <td>
            <span class="badge" :class="getStatusClass(order.status)">{{
              getStatusText(order.status)
            }}</span>
          </td>
          <td>{{ order.address }}</td>
          <td>{{ getPaymentText(order.paymethod) }}</td>
          <td class="text-success fw-bold">{{ formatPrice(order.total) }}</td>
          <td>{{ formatDate(order.created) }}</td>
          <td>
            <button
              class="btn btn-primary btn-sm me-2"
              @click="editOrder(order)"
            >
              🔄 Cập Nhật Trạng Thái
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <div class="modal fade" ref="modalRef" id="orderModal" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Cập Nhật Trạng Thái</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
            ></button>
          </div>
          <div class="modal-body">
            <select v-model="orderForm.status" class="form-control mb-2">
              <option value="1">⏳ Đang xử lý</option>
              <option value="0">✅ Hoàn tất</option>
              <option value="2">❌ Đã hủy</option>
            </select>
          </div>
          <div class="modal-footer">
            <button class="btn btn-success" @click="saveOrder">Lưu</button>
            <button class="btn btn-secondary" data-bs-dismiss="modal">
              Hủy
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import axios from "axios";
import bootstrap from "bootstrap/dist/js/bootstrap.bundle.min.js";

const API_ORDERS = "http://localhost:5000/api/orders";
const API_USERS = "http://localhost:5000/api/users";
const orders = ref([]);
const usersList = ref([]);
const searchQuery = ref("");
const modalRef = ref(null);
let modalInstance = null;

const orderForm = ref({
  id: "",
  status: 0,
});

onMounted(async () => {
  try {
    await fetchOrders();
    await fetchUsers();
    if (modalRef.value) {
      modalInstance = new bootstrap.Modal(modalRef.value);
    }
  } catch (error) {
    console.error("Lỗi khi tải dữ liệu:", error);
  }
});

const fetchOrders = async () => {
  try {
    const response = await axios.get(API_ORDERS);
    orders.value = response.data;
  } catch (error) {
    console.error("Lỗi khi tải đơn hàng:", error);
  }
};

const fetchUsers = async () => {
  try {
    const response = await axios.get(API_USERS);
    usersList.value = response.data;
  } catch (error) {
    console.error("Lỗi khi tải danh sách người dùng:", error);
  }
};

const filteredOrders = computed(() => {
  return orders.value.filter(
    (order) =>
      getUserName(order.uid)
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      order.address.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      getPaymentText(order.paymethod)
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase())
  );
});

const getUserName = (userId) => {
  const user = usersList.value.find((u) => u.id === userId);
  return user ? user.name : "Không xác định";
};

const getStatusText = (status) => {
  switch (status) {
    case 0:
      return "✅ Hoàn tất";
    case 1:
      return "⏳ Đang xử lý";
    case 2:
      return "❌ Đã hủy";
    default:
      return "Không xác định";
  }
};

const getStatusClass = (status) => {
  switch (status) {
    case 0:
      return "bg-success";
    case 1:
      return "bg-warning text-dark";
    case 2:
      return "bg-danger";
    default:
      return "bg-secondary";
  }
};

const getPaymentText = (method) => {
  switch (method) {
    case "cod":
      return "💵 Thanh toán khi nhận hàng";
    case "credit_card":
      return "💳 Thẻ tín dụng";
    case "bank_transfer":
      return "🏦 Chuyển khoản ngân hàng";
    default:
      return "❓ Không xác định";
  }
};

const formatPrice = (price) => {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
  }).format(price);
};

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString("vi-VN");
};

const editOrder = (order) => {
  orderForm.value = { id: order.id, status: order.status };
  modalInstance.show();
};

const saveOrder = async () => {
  await axios.put(`${API_ORDERS}/status/${orderForm.value.id}`, {
    status: orderForm.value.status,
  });
  await fetchOrders();
  modalInstance.hide();
};
</script>
