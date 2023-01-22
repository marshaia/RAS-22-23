<template>
    <div class="flex flex-row items-center justify-center space-x-6 p-3">
        <AdminApostasFilter class="w-3/6"/>
        <AdminApostas class="w-3/6"/>
    </div>
</template>

<script setup lang="ts">
import AdminApostas from '../components/AdminApostas.vue'
import AdminApostasFilter from '../components/AdminApostasFilter.vue'
import { useRouter } from 'vue-router'
import { loginState } from '../stores/loginStore'
import { gameState } from '../stores/gameStore'

const login = loginState();
const router = useRouter();
const games = gameState();

games.getAllGames(true);
setTimeout(games.showAllGames, 50);

if (!login.checkAdmin()) router.push({name: "home"})
</script>