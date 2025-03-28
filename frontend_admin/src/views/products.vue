<template>
  <div class="container mt-4">
    <h1 class="mb-4">🛒 Quản lý món ăn</h1>

    <div class="input-group mb-3">
      <input
        v-model="searchQuery"
        type="text"
        class="form-control"
        placeholder="🔍 Tìm kiếm món ăn..."
      />
    </div>

    <button class="btn btn-primary mb-3" @click="openModal">
      ➕ Thêm món ăn
    </button>

    <table class="table table-bordered table-striped text-center align-middle">
      <thead class="table-dark">
        <tr>
          <th>#</th>
          <th>Tên</th>
          <th>Giá</th>
          <th>Ảnh</th>
          <th style="width: 200px">Mô tả</th>
          <th>Danh mục</th>
          <th>Hành động</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(product, index) in filteredProducts" :key="product.id">
          <td>{{ index + 1 }}</td>
          <td>{{ product.name }}</td>
          <td>{{ formatPrice(product.price) }}</td>
          <td>
            <img
              :src="getImageUrl(product.id, product.image)"
              alt="Ảnh"
              width="50"
              height="50"
              class="rounded"
            />
          </td>
          <td class="text-truncate" style="max-width: 200px">
            {{ product.description }}
          </td>
          <td>{{ getCategoryName(product.category) }}</td>
          <td>
            <button
              class="btn btn-warning btn-sm me-2"
              @click="editProduct(product)"
            >
              ✏️ Sửa
            </button>
            <button
              class="btn btn-danger btn-sm"
              @click="deleteProduct(product.id)"
            >
              🗑️ Xóa
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <div class="modal fade" ref="modalRef" id="productModal" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">
              {{ isEditing ? "Sửa Sản phẩm" : "Thêm Sản phẩm" }}
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
            ></button>
          </div>
          <div class="modal-body">
            <input
              v-model="productForm.name"
              type="text"
              class="form-control mb-2"
              placeholder="Tên sản phẩm"
            />
            <input
              v-model="productForm.price"
              type="number"
              class="form-control mb-2"
              placeholder="Giá"
            />
            <input
              type="file"
              @change="handleImageUpload"
              class="form-control mb-2"
            />
            <textarea
              v-model="productForm.description"
              class="form-control mb-2"
              placeholder="Mô tả"
            ></textarea>
            <select v-model="productForm.category" class="form-control mb-2">
              <option disabled value="">Chọn danh mục</option>
              <option v-for="cat in categoryList" :key="cat.id" :value="cat.id">
                {{ cat.name }}
              </option>
            </select>
          </div>
          <div class="modal-footer">
            <button class="btn btn-success" @click="saveProduct">
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

const API_URL = "http://localhost:5000/api/products";
const API_URL_CATEGORIES = "http://localhost:5000/api/categories";
const products = ref([]);
const categoryList = ref([]);
const searchQuery = ref("");
const isEditing = ref(false);
const modalRef = ref(null);
let modalInstance = null;

const productForm = ref({
  id: "",
  name: "",
  price: 0,
  image: "",
  description: "",
  category: "",
});

onMounted(async () => {
  await fetchProducts();
  await fetchCategories();
  if (modalRef.value) {
    modalInstance = new bootstrap.Modal(modalRef.value);
  }
});

const fetchProducts = async () => {
  const response = await axios.get(API_URL);
  products.value = response.data;
};

const fetchCategories = async () => {
  const response = await axios.get(API_URL_CATEGORIES);
  categoryList.value = response.data;
};

const filteredProducts = computed(() => {
  return products.value.filter(
    (product) =>
      product.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      getCategoryName(product.category)
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase())
  );
});

const getCategoryName = (categoryId) => {
  const category = categoryList.value.find((c) => c.id === categoryId);
  return category ? category.name : "Không xác định";
};

const getImageUrl = (id, image) => {
  return image
    ? `http://192.168.1.4:8090/api/files/products/${id}/${image}`
    : "https://via.placeholder.com/80";
};

const formatPrice = (price) => {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
  }).format(price);
};

const openModal = () => {
  productForm.value = {
    id: "",
    name: "",
    price: 0,
    image: "",
    description: "",
    category: "",
  };
  isEditing.value = false;
  modalInstance.show();
};

const editProduct = (product) => {
  productForm.value = { ...product };
  isEditing.value = true;
  modalInstance.show();
};

const handleImageUpload = (event) => {
  const file = event.target.files[0];
  if (file) {
    productForm.value.image = file;
  }
};

const saveProduct = async () => {
  const formData = new FormData();
  formData.append("name", productForm.value.name);
  formData.append("price", productForm.value.price);
  formData.append("description", productForm.value.description);
  formData.append("category", productForm.value.category);
  if (productForm.value.image) {
    formData.append("image", productForm.value.image);
  }

  if (isEditing.value) {
    await axios.put(`${API_URL}/${productForm.value.id}`, formData);
  } else {
    await axios.post(API_URL, formData);
  }

  await fetchProducts();
  modalInstance.hide();
};

const deleteProduct = async (id) => {
  await axios.delete(`${API_URL}/${id}`);
  await fetchProducts();
};
</script>
