<template>
    <div class="flex items-center justify-center space-x-6 p-3">
        <AdminPromos class="w-3/5"/>
        <AdminPromosEditar class="w-2/5"/>
    </div>
</template>

<script setup lang="ts">
import AdminPromos from '../components/AdminPromos.vue'
import AdminPromosEditar from '../components/AdminPromosEditar.vue'
import { useRouter } from 'vue-router'
import { loginState } from '../stores/loginStore'

const login = loginState();
const router = useRouter();

if (!login.checkAdmin()) router.push({name: "home"})
</script>