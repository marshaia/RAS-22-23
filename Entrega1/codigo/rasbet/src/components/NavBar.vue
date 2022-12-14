<template>
  <nav class="h-full w-full bg-white dark:bg-black flex items-center px-4">
    <router-link to="/" tag="img">
      <img
        class="block h-12 w-auto"
        src="../assets/logoGold.png"
        alt="RasBet Logo"
      />
    </router-link>
    <div class="grow"></div>

    <Notifications v-if="login.loggedIn"/>

    <router-link v-if="!login.loggedIn" to="/login">
      <button
        type="button"
        class="rounded-full mr-2 p-1 text-rasbet-logo-gold hover:ring-2 hover:ring-rasbet-logo-gold focus:outline-none focus:ring-2 focus:ring-rasbet-logo-gold"
      >
        <ArrowLeftOnRectangleIcon class="h-8" />
      </button>
    </router-link>

    <router-link v-if="login.loggedIn" to="/profile">
      <button
        type="button"
        class="mr-2 rounded-full p-1 text-rasbet-logo-gold hover:ring-2 hover:ring-rasbet-logo-gold focus:outline-none focus:ring-2 focus:ring-rasbet-logo-gold"
      >
        <UserIcon class="h-8" />
      </button>
    </router-link>

    <button v-if="login.loggedIn"
      type="button"
      @click.prevent="logOut"
      class="rounded-full mr-2 p-1 text-rasbet-logo-gold hover:ring-2 hover:ring-rasbet-logo-gold focus:outline-none focus:ring-2 focus:ring-rasbet-logo-gold"
    >
      <ArrowRightOnRectangleIcon class="h-8" />
    </button>

  </nav>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
import { loginState } from '../stores/loginStore'
import {
  ArrowLeftOnRectangleIcon,
  ArrowRightOnRectangleIcon,
  UserIcon,
  BellIcon,
} from "@heroicons/vue/24/outline";
import Notifications from './Notifications.vue';


const router = useRouter();
const login = loginState();

const logOut = () => {
  login.logOut()
  router.push({name: "home"})
}
</script>
