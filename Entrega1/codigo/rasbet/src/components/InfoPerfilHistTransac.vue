<template>
  <div class="h-full rounded-2xl bg-white dark:bg-black p-2">
    <div
      class="font-semibold text-2xl text-center text-rasbet-logo-gold border-b-2 border-rasbet-logo-gold pb-2 mb-3"
    >
      Transactions History
    </div>

    <div class="flex justify-center">
      <span v-if="login.user?.historicoTransacos?.length == 0"
      class="dark:text-white">
        Nothing to show yet...</span
      >
    </div>
  </div>
</template>

<script setup lang="ts">
import { loginState } from "../stores/loginStore";

const login = loginState();
</script>
