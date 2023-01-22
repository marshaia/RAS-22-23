<template>
    <div class="flex flex-col grow">
      <div class="text-xl font-semibold text-rasbet-logo-gold text-center mb-2 pb-2 border-b-2 border-rasbet-logo-gold">
        Filtrar por Apostador
      </div>
      <div class="rounded-3xl shadow-xl border-2 border-gray-300 p-2 max-h-60 overflow-auto text-lg no-scrollbar">

        <div v-for="user in login.adminUsers" :key="user.idapostador" class="flex flex-col">
          <button @click.prevent="toggleSport(user.idapostador)">
            <div class="flex flex-row items-center rounded-xl outline outline-1 outline-gray-600 p-2 shadow-md bg-white dark:bg-black dark:hover:bg-rasbet-view-black hover:bg-blue-200 m-1" :class="active === user.idapostador ? 'dark:bg-green-400 bg-green-400' : ''">
              
              <UserIcon class="h-7 text-black dark:text-white"/>

              <div class="dark:text-white text-black text-md ml-2">{{ user.nome }}</div>
            
            </div>
          </button>
        </div>

      </div>
    </div>
  </template>
  
<script setup lang="ts">
import { UserIcon } from '@heroicons/vue/24/outline';
import { ref } from 'vue'
import { loginState } from '../stores/loginStore';

const login = loginState();
login.getAdminUsers();

const active = ref()
  
const toggleSport = (id: number) => {
    if (active.value === id) {
        login.resetAdminApostas()
        active.value = null;
    }
    else {
        login.filterAdminApostasByUser(id)
        active.value = id;
    }
}
</script>
  
  
<style>
.no-scrollbar::-webkit-scrollbar {
    display: none;
}
  
/* Hide scrollbar for IE, Edge and Firefox */
.no-scrollbar {
    -ms-overflow-style: none; /* IE and Edge */
    scrollbar-width: none; /* Firefox */
}
</style>