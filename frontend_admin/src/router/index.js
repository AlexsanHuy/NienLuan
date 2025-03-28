import { createRouter, createWebHistory } from "vue-router";
import Dashboard from "@/views/dashboard.vue";
import Products from "@/views/products.vue";
import Categories from "@/views/categories.vue";
import Accounts from "@/views/accounts.vue";
import Orders from "@/views/orders.vue";
import Discount from "@/views/discount.vue";
import Feedback from "@/views/feedback.vue";

const routes = [
  { path: "/", component: Dashboard },
  { path: "/products", component: Products },
  { path: "/categories", component: Categories },
  { path: "/accounts", component: Accounts },
  { path: "/orders", component: Orders },
  { path: "/discount", component: Discount },
  { path: "/feedback", component: Feedback },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
