<template>
  <div class="container mt-4">
    <h1 class="mb-4">👤 Phản hồi khách hàng</h1>
    <div class="input-group mb-3">
      <input
        v-model="searchQuery"
        type="text"
        class="form-control"
        placeholder="🔍 Tìm kiếm phản hồi..."
      />
    </div>

    <table class="table table-bordered table-striped text-center align-middle">
      <thead class="table-dark">
        <tr>
          <th>#</th>
          <th>Tên</th>
          <th>Nội dung</th>
          <th>Hành động</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(feedback, index) in filteredFeedbacks" :key="feedback.id">
          <td>{{ index + 1 }}</td>
          <td>{{ feedback.userName }}</td>
          <td>{{ feedback.feedback }}</td>
          <td>
            <button
              class="btn btn-danger btn-sm"
              @click="deleteFeedback(feedback.id)"
            >
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

const API_URL_FEEDBACK = "http://localhost:5000/api/feedback";
const API_URL_USER = "http://localhost:5000/api/users";

const feedbacks = ref([]);
const users = ref([]);
const searchQuery = ref("");

onMounted(async () => {
  await fetchUsers();
  await fetchFeedbacks();
});

const fetchFeedbacks = async () => {
  try {
    const response = await axios.get(API_URL_FEEDBACK);
    feedbacks.value = response.data;
  } catch (error) {
    console.error("Lỗi khi lấy danh sách phản hồi:", error);
  }
};

const fetchUsers = async () => {
  try {
    const response = await axios.get(API_URL_USER);
    users.value = response.data;
  } catch (error) {
    console.error("Lỗi khi lấy danh sách người dùng:", error);
  }
};

const feedbacksWithNames = computed(() => {
  return feedbacks.value.map((feedback) => {
    const user = users.value.find((user) => user.id === feedback.feedback_uid);
    return {
      ...feedback,
      userName: user ? user.name : "Không tìm thấy",
    };
  });
});

const filteredFeedbacks = computed(() => {
  return feedbacksWithNames.value.filter(
    (feedback) =>
      feedback.userName
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      feedback.feedback.toLowerCase().includes(searchQuery.value.toLowerCase())
  );
});

const deleteFeedback = async (id) => {
  try {
    await axios.delete(`${API_URL_FEEDBACK}/${id}`);
    await fetchFeedbacks();
  } catch (error) {
    console.error("Lỗi khi xóa phản hồi:", error);
  }
};
</script>
