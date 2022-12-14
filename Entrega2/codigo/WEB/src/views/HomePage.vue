<template>
  <div v-if="!checkAdmin()" class="flex items-center justify-center space-x-6 p-3">
    <SportsSideBar class="w-1/6"/>
    <HPGames class="w-3/6"/>
    <HPBetCart v-if="!checkEspecialista()" class="w-2/6" />
    <EspecialistaInserirOdd v-else-if="checkEspecialista() && login.loggedIn" class="w-2/6" />
  </div>



  <div v-else class="flex flex-row items-center space-x-6 p-3">
    <div class="w-1/5 mx-40">
      <img
        class="block w-full"
        src="../assets/logoBall.png"
        alt="RasBet Logo"
      />
    </div>
    <div class="w-4/5 ">
      <div class="text-rasbet-logo-gold text-7xl font-semibold ">Bem-vindo {{login.user?.nome}}!</div>
      <div class="dark:text-white text-black text-3xl mt-20">Estatísticas do sistema em tempo real: </div>

      <div class="text-2xl dark:text-white text-black mt-5">
        <span class="text-rasbet-logo-gold">-></span> Número de utilizadores online: 
        <span class="text-green-600 text-3xl">{{numUsers}}</span>
      </div>

      <div class="text-2xl dark:text-white text-black mt-5">
        <span class="text-rasbet-logo-gold">-></span> Número de Desportos no sistema: 
        <span class="text-green-600 text-3xl">{{games.allSports.size}}</span>
      </div>

      <div class="text-2xl dark:text-white text-black mt-5">
        <span class="text-rasbet-logo-gold">-></span> Número de Competições no sistema: 
        <span class="text-green-600 text-3xl">{{games.allCompetitions.size}}</span>
      </div>

      
      <div class="text-2xl dark:text-white text-black mt-5">
        <span class="text-rasbet-logo-gold">-></span> Número de Jogos no sistema: 
        <span class="text-green-600 text-3xl">{{games.allGames.size}}</span>
      </div>
    </div>

  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import SportsSideBar from '../components/HPSideBar.vue';
import HPGames from '../components/HPGames.vue';
import HPBetCart from '../components/HPBetCart.vue';
import { loginState } from '../stores/loginStore'
import { computed } from 'vue'
import EspecialistaInserirOdd from '../components/EspecialistaInserirOdd.vue'
import { getNumUsersOnline } from '../api/rasbetGETApi'
import { gameState } from '../stores/gameStore'

const games = gameState();
const login = loginState(); 
const loggedIn = computed(() => login.loggedIn);

const checkEspecialista = () => {
  if (loggedIn) {
    let e = login.getUtilizadorEncargo()
    if (e) return /especialista/gi.test(e.toString());
    else return false;
  }
  else return false;
}

const checkAdmin = () => {
  if (loggedIn) {
    let e = login.getUtilizadorEncargo()
    if (e) return /admin/gi.test(e.toString());
    else return false;
  }
  else return false;
}

const numUsers = ref<number>(0);
const numUsersOnline = () => {
  getNumUsersOnline(login.token).then((res) => {
    if (res.code === 200) numUsers.value = res.data - 1;
    return;
  })
}
if (checkAdmin()) numUsersOnline();
</script>