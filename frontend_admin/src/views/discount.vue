<template>
  <div class="container mt-4">
    <h1 class="mb-4">🛒 Quản lý khuyến mãi</h1>

    <div class="input-group mb-3">
      <input
        v-model="searchQuery"
        type="text"
        class="form-control"
        placeholder="🔍 Tìm kiếm món ăn..."
      />
    </div>

    <table class="table table-bordered table-striped text-center align-middle">
      <thead class="table-dark">
        <tr>
          <th>#</th>
          <th>Tên</th>
          <th>Giá</th>
          <th>Danh mục</th>
          <th>Giá sau khi giảm</th>
          <th width="10%">Giảm giá</th>
          <th>Có/Không</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(product, index) in filteredProducts" :key="product.id">
          <td>{{ index + 1 }}</td>
          <td>{{ product.name }}</td>
          <td>{{ formatPrice(product.price) }}</td>
          <td>{{ getCategoryName(product.category) }}</td>
          <td>
            {{
              formatPrice(
                product.price - (product.sale_value / 100) * product.price
              )
            }}
          </td>
          <td>
            <div class="d-flex align-items-center gap-2">
              <input
                type="number"
                v-model="product.sale_value"
                class="form-control"
              />
              <button
                class="btn btn-success btn-sm"
                @click="updateDiscount(product.id)"
              >
                <i class="fa fa-edit"></i>
              </button>
            </div>
          </td>
          <td>
            <button
              v-if="product.sale"
              class="btn btn-success btn-sm"
              @click="unSale(product.id)"
            >
              <i class="fa fa-check"></i>
            </button>
            <button
              v-else
              class="btn btn-danger btn-sm"
              @click="updateSale(product.id)"
            >
              <i class="fa fa-times"></i>
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

const API_URL = "http://localhost:5000/api/products";
const API_URL_CATEGORIES = "http://localhost:5000/api/categories";
const products = ref([]);
const categoryList = ref([]);
const searchQuery = ref("");

onMounted(async () => {
  await fetchProducts();
  await fetchCategories();
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

const formatPrice = (price) => {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
  }).format(price);
};

const updateDiscount = async (id) => {
  try {
    const product = products.value.find((p) => p.id === id);
    await axios.post(`${API_URL}/discount/${id}`, {
      sale_value: product.sale_value,
    });
    await fetchProducts();
  } catch (error) {
    console.error("Lỗi khi cập nhật giảm giá:", error);
  }
};

const updateSale = async (id) => {
  try {
    await axios.post(`${API_URL}/sale/${id}`);
    await fetchProducts();
  } catch (error) {
    console.error("Lỗi khi cập nhật khuyến mãi:", error);
  }
};

const unSale = async (id) => {
  try {
    await axios.post(`${API_URL}/unsale/${id}`);
    await fetchProducts();
  } catch (error) {
    console.error("Lỗi khi hủy khuyến mãi:", error);
  }
};
</script>
