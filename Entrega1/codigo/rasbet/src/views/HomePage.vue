<template>
  <div class="flex items-center justify-center space-x-6 p-3">
    <SportsSideBar class="w-1/6"/>
    <HPGames class="w-3/6"/>
    <HPBetCart class="w-2/6"/>
  </div>
</template>

<script setup lang="ts">
import SportsSideBar from '../components/HPSideBar.vue';
import HPGames from '../components/HPGames.vue';
import HPBetCart from '../components/HPBetCart.vue';
</script>