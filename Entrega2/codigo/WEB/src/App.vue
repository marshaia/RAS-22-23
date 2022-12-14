<template>
  <main>
    <div class="flex flex-col h-screen">
      <div class="flex sticky top-0 z-15" style="height: 10%;">
        <nav-bar />
      </div>

      <div class="flex flex-1 flex-grow relative">
        <router-view
          class="bg-gray-200 dark:bg-rasbet-view-black h-full w-full"
        ></router-view>
      </div>
    </div>
  </main>
</template>

<script setup lang="ts">
import NavBar from "./components/NavBar.vue";
import { cartState } from './stores/cart'
import { gameState } from './stores/gameStore'
import { loginState } from './stores/loginStore'

const login = loginState();
login.checkLogin();

const games = gameState();
games.bootGames();

cartState();

</script>
