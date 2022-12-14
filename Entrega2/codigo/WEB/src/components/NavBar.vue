<template>
  <nav class="h-full w-full bg-white dark:bg-black flex items-center px-4">
    <router-link to="/" tag="img">
      <img
        class="block h-12 w-auto"
        src="../assets/logoGold.png"
        alt="RasBet Logo"
      />
    </router-link>

    <div v-if="checkAdmin()" class="ml-14">
      <router-link to="/admin/apostas">
        <button
          type="button"
          class="rounded-full mr-2 p-2 text-rasbet-logo-gold font-semibold hover:ring-2 hover:ring-rasbet-logo-gold focus:outline-none focus:ring-2 focus:ring-rasbet-logo-gold focus:bg-rasbet-logo-gold focus:text-white dark:focus:text-black">
          Apostas
        </button>
      </router-link> 

      <router-link to="/admin/jogos">
        <button
          type="button"
          class="rounded-full mr-2 p-2 text-rasbet-logo-gold font-semibold hover:ring-2 hover:ring-rasbet-logo-gold focus:outline-none focus:ring-2 focus:ring-rasbet-logo-gold focus:bg-rasbet-logo-gold focus:text-white dark:focus:text-black">
          Jogos
        </button>
      </router-link> 

      <router-link to="/admin/promos">
        <button
          type="button"
          class="rounded-full mr-2 p-2 text-rasbet-logo-gold font-semibold hover:ring-2 hover:ring-rasbet-logo-gold focus:outline-none focus:ring-2 focus:ring-rasbet-logo-gold focus:bg-rasbet-logo-gold focus:text-white dark:focus:text-black">
          Promoções
        </button>
      </router-link> 

      <router-link to="/admin/contas">
        <button
          type="button"
          class="rounded-full mr-2 p-2 text-rasbet-logo-gold font-semibold hover:ring-2 hover:ring-rasbet-logo-gold focus:outline-none focus:ring-2 focus:ring-rasbet-logo-gold focus:bg-rasbet-logo-gold focus:text-white dark:focus:text-black">
          Contas
        </button>
      </router-link> 

    </div>



    <div class="grow"></div>

    <!-- ÁREA PESSOAL -->
    <router-link v-if="login.loggedIn && checkApostador()" to="/profile">
      <button
        type="button"
        class="rounded-full mr-2 p-2 text-rasbet-logo-gold font-semibold hover:ring-2 hover:ring-rasbet-logo-gold focus:outline-none focus:ring-2 focus:ring-rasbet-logo-gold focus:bg-rasbet-logo-gold focus:text-white dark:focus:text-black">
        Área Pessoal
      </button>
    </router-link> 
    

    <!-- NOTIFICAÇÕES -->
    <div v-if="login.loggedIn">
      <div class="inline-flex relative w-fit">
        <!-- vai ter de ter um if para ter ou nao a bolinha de novas notificações -->
        <div v-if="lengthNotifs > 0" class="absolute inline-block top-0 right-0 bottom-auto left-auto -translate-x-2.5 -translate-y-1/5 rotate-0 skew-x-0 skew-y-0 scale-x-50 scale-y-50 p-2.5 text-xs bg-black dark:bg-white rounded-full z-10"></div>
        <button
          class="mr-2 p-1 text-rasbet-logo-gold font-medium text-xs rounded-full hover:ring-2 hover:ring-rasbet-logo-gold focus:outline-none focus:ring-2 focus:ring-rasbet-logo-gold focus:bg-rasbet-logo-gold focus:text-white dark:focus:text-black"
          type="button"
          @click="openModal=true">
            <BellIcon class="h-8"/>
        </button>
      </div>
      
      <BaseModalNotifications :is-open="openModal" @close="closeModal" />
    </div>


    <!-- LOG OUT -->
    <button v-if="login.loggedIn"
      type="button"
      @click.prevent="logOut"
      class="rounded-full mr-2 p-2 text-rasbet-logo-gold font-semibold hover:ring-2 hover:ring-rasbet-logo-gold focus:outline-none focus:ring-2 focus:ring-rasbet-logo-gold focus:bg-rasbet-logo-gold focus:text-white dark:focus:text-black">
      Log Out
    </button>


    <!-- LOG IN -->
    <router-link v-if="!login.loggedIn" to="/login">
      <button
        type="button"
        class="rounded-full mr-2 p-2 text-rasbet-logo-gold font-semibold hover:ring-2 hover:ring-rasbet-logo-gold focus:outline-none focus:ring-2 focus:ring-rasbet-logo-gold focus:bg-rasbet-logo-gold focus:text-white dark:focus:text-black">
        Log In
      </button>
    </router-link>

  </nav>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router'
import { loginState } from '../stores/loginStore'
import { BellIcon } from '@heroicons/vue/24/outline'
import BaseModalNotifications from '../components/BaseModalNotifications.vue'

const openModal = ref<boolean>(false);

const router = useRouter();
const login = loginState();

const loggedIn = computed(() => login.loggedIn);

const checkApostador = () => {
  if (loggedIn) {
    let e = login.getUtilizadorEncargo()
    if (e) return /apostador/gi.test(e.toString());
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

const lengthNotifs = computed(() => login.notificacoes?.length ?? 0);

const closeModal = () => {
  openModal.value = false;
}

const logOut = () => {
  login.logOut()
  router.push({name: "home"})
}
</script>
