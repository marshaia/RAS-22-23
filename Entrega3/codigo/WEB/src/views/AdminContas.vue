<template>
    <div class="flex items-center justify-center p-3">
        <AdminContasEditar class="w-4/5"/>
    </div>
</template>

<script setup lang="ts">
import AdminContasEditar from '../components/AdminContasEditar.vue'
import { useRouter } from 'vue-router'
import { loginState } from '../stores/loginStore'

const login = loginState();
const router = useRouter();

if (!login.checkAdmin()) router.push({name: "home"})
</script>