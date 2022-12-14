<template>
    <div class="flex items-center justify-center space-x-6 p-3">
        <AdminApostas class="w-3/5"/>
        <AdminApostasEditar class="w-2/5"/>
    </div>
</template>

<script setup lang="ts">
import AdminApostas from '../components/AdminApostas.vue'
import AdminApostasEditar from '../components/AdminApostasEditar.vue'
import { useRouter } from 'vue-router'
import { loginState } from '../stores/loginStore'

const login = loginState();
const router = useRouter();

const checkAdmin = () => {
  if (login.loggedIn) {
    let e = login.getUtilizadorEncargo()
    if (e) return /admin/gi.test(e.toString());
    else return false;
  }
  else return false;
}

if (!checkAdmin()) router.push({name: "home"})
</script>