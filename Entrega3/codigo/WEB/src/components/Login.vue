<template>
  <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-2 px-8 w-[450px]">
    <div class="flex flex-row">
      <div class="grow">
        <h1 class="text-xl text-rasbet-logo-gold font-semibold mt-10">
          Bem-vindo de volta!
        </h1>
        <small class="text-gray-500 dark:text-gray-300">
          Por favor insira as suas credenciais de acesso
        </small>
      </div>
      <img
        class="mt-5 h-20 w-auto"
        src="../assets/logoBall.png"
        alt="RasBet Logo"
      />
    </div>

    <!-- Form -->
    <form class="mt-10" @submit.prevent="formSubmit">
      <div class="mb-5">
        <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold"
          >Email</label
        >
        <input
          type="email"
          placeholder="Enter your email"
          class="block w-full text-sm rounded-md border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none py-2 px-1.5 dark:bg-rasbet-view-black dark:text-gray-200"
          v-model="email"
          @input="error=false"
          required
        />
      </div>

      <div class="mb-2">
        <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold"
          >Password</label
        >
        <input
          type="password"
          placeholder="*****"
          class="block w-full text-sm rounded-md border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none py-2 px-1.5 dark:bg-rasbet-view-black dark:text-gray-200"
          v-model="password"
          @input="error=false"
          required
        />
      </div>

      <div class="mb-2 flex flex-wrap content-center">
        <span v-if="error" class="text-xs font-semibold text-red-500 ">Credenciais Erradas!</span>
      </div>

      <div class="">
        <button
          class="mt-6 mb-1.5 block w-full text-center text-white bg-rasbet-logo-gold hover:bg-yellow-500 px-2 py-1.5 rounded-md"
          :class="{ 'bg-yellow-500': email.length > 0 && password.length > 0 }"
        >
          <spinningButton v-if="login.fetching" />  
          <span v-else> Entrar </span>
        </button>
      </div>
    </form>
    <div class="my-4 text-center">
      <span class="text-xs text-gray-500 font-semibold"
        >Não tens conta?
      </span>
      <router-link to="/register">
        <button>
          <span class="text-xs font-semibold text-rasbet-logo-gold underline">Registar</span>
        </button>
      </router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { useRouter } from 'vue-router'
import { loginState } from '../stores/loginStore'
import spinningButton from '../assets/spiningButton.vue'

const login = loginState();
const router = useRouter();
const error = ref<boolean>(false);
const email = ref<string>("");
const password = ref<string>("");

const formSubmit = () => {
  login.login(email.value, password.value).then(log => {
    if (log) {
      while(login.user === null) {}
      router.push({name: "home"});
    }
    else {
      error.value = true
      email.value = ""
      password.value = ""
    }
  });
};
</script>
