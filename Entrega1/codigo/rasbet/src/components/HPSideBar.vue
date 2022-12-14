<template>
  <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-3 px-8 h-full w-full">
    <div class="flex flex-col space-y-6 h-full">
      <HPSideBarDesporto />
      <div class="flex-grow"></div>
      <HPSideBarDesporto />
    </div>
  </div>
</template>

<script setup lang="ts">
import HPSideBarDesporto from "./HPSideBarDesporto.vue";
</script>
