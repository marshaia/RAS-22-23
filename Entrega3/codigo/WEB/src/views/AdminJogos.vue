<template>
    <div class="flex items-center justify-center space-x-6 p-3">
        <SportsSideBar class="w-1/6"/>
        <AdminJogos class="w-3/6"/>
        <AdminJogosEditar class="w-2/6"/>
    </div>
</template>

<script setup lang="ts">
import AdminJogos from '../components/AdminJogos.vue'
import AdminJogosEditar from '../components/AdminJogosEditar.vue'
import SportsSideBar from '../components/HPSideBar.vue';
import { useRouter } from 'vue-router'
import { loginState } from '../stores/loginStore'

const login = loginState();
const router = useRouter();

if (!login.checkAdmin()) router.push({name: "home"})
</script>