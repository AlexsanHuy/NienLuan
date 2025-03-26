<template>
  <div class="container mt-4">
    <h1 class="mb-4">🍽️ Quản lý loại món ăn</h1>

    <div class="input-group mb-3">
      <input
        v-model="searchQuery"
        type="text"
        class="form-control"
        placeholder="🔍 Tìm kiếm loại món ăn..."
      />
    </div>

    <button class="btn btn-primary mb-3" @click="openModal">
      ➕ Thêm loại món ăn
    </button>

    <table class="table table-bordered table-striped text-center align-middle">
      <thead class="table-dark">
        <tr>
          <th>#</th>
          <th>Tên loại món ăn</th>
          <th>Hành động</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(category, index) in filteredCategories" :key="category.id">
          <td>{{ index + 1 }}</td>
          <td>{{ category.name }}</td>
          <td>
            <button
              class="btn btn-warning btn-sm me-2"
              @click="editCategory(category)"
            >
              ✏️ Sửa
            </button>
            <button
              class="btn btn-danger btn-sm"
              @click="deleteCategory(category.id)"
            >
              🗑️ Xóa
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <div class="modal fade" id="categoryModal" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">
              {{ isEditing ? "Sửa loại món ăn" : "Thêm loại món ăn" }}
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
            ></button>
          </div>
          <div class="modal-body">
            <input
              v-model="categoryForm.name"
              type="text"
              class="form-control mb-2"
              placeholder="Tên loại món ăn"
            />
          </div>
          <div class="modal-footer">
            <button class="btn btn-success" @click="saveCategory">
              {{ isEditing ? "Cập Nhật" : "Thêm" }}
            </button>
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

const API_URL = "http://localhost:5000/api/categories";
const categories = ref([]);
const searchQuery = ref("");
const isEditing = ref(false);
const categoryForm = ref({ id: "", name: "" });
let modalInstance = null;

onMounted(async () => {
  await fetchCategories();
  modalInstance = new bootstrap.Modal(document.getElementById("categoryModal"));
});

const fetchCategories = async () => {
  try {
    const response = await axios.get(API_URL);
    categories.value = response.data;
  } catch (error) {
    console.error("Lỗi khi lấy danh sách loại món ăn:", error);
  }
};

const filteredCategories = computed(() => {
  return categories.value.filter((category) =>
    category.name.toLowerCase().includes(searchQuery.value.toLowerCase())
  );
});

const openModal = () => {
  categoryForm.value = { id: "", name: "" };
  isEditing.value = false;
  modalInstance.show();
};

const editCategory = (category) => {
  categoryForm.value = { ...category };
  isEditing.value = true;
  modalInstance.show();
};

const saveCategory = async () => {
  try {
    if (isEditing.value) {
      await axios.put(`${API_URL}/${categoryForm.value.id}`, {
        name: categoryForm.value.name,
      });
    } else {
      await axios.post(API_URL, {
        name: categoryForm.value.name,
      });
    }
    await fetchCategories();
    modalInstance.hide();
  } catch (error) {
    console.error("Lỗi khi lưu loại món ăn:", error);
  }
};

const deleteCategory = async (id) => {
  try {
    await axios.delete(`${API_URL}/${id}`);
    await fetchCategories();
  } catch (error) {
    console.error("Lỗi khi xóa loại món ăn:", error);
  }
};
</script>
