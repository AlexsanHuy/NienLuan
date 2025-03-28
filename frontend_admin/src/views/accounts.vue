<template>
  <div class="container mt-4">
    <h1 class="mb-4">👤 Quản lý người dùng</h1>

    <div class="input-group mb-3">
      <input
        v-model="searchQuery"
        type="text"
        class="form-control"
        placeholder="🔍 Tìm kiếm người dùng..."
      />
    </div>

    <table class="table table-bordered table-striped text-center align-middle">
      <thead class="table-dark">
        <tr>
          <th>#</th>
          <th>Tên</th>
          <th>SDT</th>
          <th>Hành động</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(user, index) in filteredUsers" :key="user.id">
          <td>{{ index + 1 }}</td>
          <td>{{ user.name }}</td>
          <td>{{ user.phone }}</td>
          <td>
            <button class="btn btn-danger btn-sm" @click="deleteUser(user.id)">
              🗑️ Xóa
            </button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import axios from "axios";

const API_URL = "http://localhost:5000/api/users";
const users = ref([]);
const searchQuery = ref("");

onMounted(async () => {
  await fetchUsers();
});

const fetchUsers = async () => {
  try {
    const response = await axios.get(API_URL);
    users.value = response.data;
  } catch (error) {
    console.error("Lỗi khi lấy danh sách người dùng:", error);
  }
};

const filteredUsers = computed(() => {
  return users.value.filter((user) =>
    user.name.toLowerCase().includes(searchQuery.value.toLowerCase())
  );
});

const deleteUser = async (id) => {
  try {
    await axios.delete(`${API_URL}/${id}`);
    await fetchUsers();
  } catch (error) {
    console.error("Lỗi khi xóa người dùng:", error);
  }
};
</script>
