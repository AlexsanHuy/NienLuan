<template>
  <div class="d-flex">
    <Sidebar />
    <div class="content p-4" style="flex: 1">
      <RouterView />
    </div>
  </div>
</template>

<script setup>
import Sidebar from "@/components/Sidebar.vue";
import { RouterView } from "vue-router";
</script>
