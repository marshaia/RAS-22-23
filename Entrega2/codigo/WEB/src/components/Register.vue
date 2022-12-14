<template>
  <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-2 px-10">
    <div class="flex flex-row">
      <div class="grow">
        <h1 class="text-xl text-rasbet-logo-gold font-semibold mt-4">
          Bem-vindo ao RASBET!
        </h1>
        <small class="text-gray-500 dark:text-gray-300"
          >Por favor insere os teus dados pessoais</small
        >
      </div>
      <img
        class="mt-1 h-20 w-auto"
        src="../assets/logoBall.png"
        alt="RasBet Logo"
      />
    </div>

    <div v-if="errorFetching || errorPassword" class="text-red-600 font-semibold text-sm">
      <span v-if="errorFetching"> ! Erro ao registar, por favor tente mais tarde !</span>
      <span v-if="errorPassword"> ! As passwords não coincidem !</span>
    </div>

    <!-- Form -->
    <form class="mt-5" @submit.prevent="formSubmit">
      <!-- Name and Birth Date -->
      <div class="flex flex-rows space-x-4">
        <div class="w-1/2">
          <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold"
            >Nome</label
          >
          <input
            type="text"
            placeholder="Primeiro e último nome"
            class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
            v-model="name"
            required
          />
        </div>
        <div class="w-1/2">
          <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold"
            >Data de Nascimento</label
          >
          <input
            type="date"
            :max="minAge"
            class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
            v-model="birthDate"
            required
          />
        </div>
      </div>

      <!-- Email -->
      <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold"
        >Email</label
      >
      <input
        type="email"
        placeholder="your@email.com"
        class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
        v-model="email"
        required
      />

      <!-- Password -->
      <div class="flex flex-rows space-x-4">
        <div class="w-1/2">
          <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold"
            >Password</label
          >
          <input
            type="password"
            placeholder="*****"
            class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
            v-model="password"
            required
          />
        </div>
        <div class="w-1/2">
          <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold"
            >Confirmar Password</label
          >
          <input
            type="password"
            placeholder="*****"
            class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
            v-model="confPassword"
            required
          />
        </div>
      </div>

      <!-- Address -->
      <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold"
        >Endereço</label
      >
      <input
        type="text"
        placeholder="Rua Rasbet, nº 56"
        class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
        v-model="address"
        required
      />

      <!-- NIF -->
      <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold"
        >NIF</label
      >
      <input
        placeholder="NIF"
        pattern="[0-9]{9}"
        class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
        v-model="nif"
      />

      <!-- Cellphone number and CC-->
      <div class="flex flex-row space-x-4">
        <div class="w-1/2">
          <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold"
            >Nº Cartão de Cidadãor</label
          >
          <input
            type="text"
            placeholder="XXX XXX XXX"
            pattern="[0-9]{9}"
            class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
            v-model="citizenNumber"
            required
          />
        </div>
        <div class="w-1/2">
          <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold"
            >Telemóvel</label
          >
          <input
            type="text"
            placeholder="XXX XXX XXX"
            pattern="[0-9]{9}"
            class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
            v-model="cellNumber"
            required
          />
        </div>
      </div>

      <div class="mb-2">
        <button
          class="mt-5 mb-1.5 block w-full text-center text-white bg-rasbet-logo-gold hover:bg-yellow-500 px-2 py-1.5 rounded-md"
        >
          <span v-if="login.fetching"> <spinningButton/> </span>
          <span v-else>Registar</span>
        </button>
      </div>
    </form>
    
    <div class="text-center">
      <span class="text-xs text-gray-500 font-semibold">
        Já tens uma conta?
      </span>
      <router-link to="/login">
        <button class="text-xs font-semibold text-rasbet-logo-gold underline">
          Log In
        </button>
      </router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { useRouter } from 'vue-router'
import { loginState } from '../stores/loginStore'

const login = loginState();
const router = useRouter();

const errorFetching = ref<boolean>(false);
const errorPassword = ref<boolean>(false);

const name = ref<string>("");
const address = ref<string>("");
const citizenNumber = ref<string>("");
const cellNumber = ref<string>("");
const email = ref<string>("");
const password = ref<string>("");
const confPassword = ref<string>("");
const nif = ref<number>();

const date = new Date();
date.setFullYear(date.getFullYear() - 18);

const birthDate = ref(date.toISOString().split("T")[0]);

const minAge = date.toISOString().split("T")[0];

const formSubmit = () => {

  if (password.value !== confPassword.value) {
    errorPassword.value = true;
    return
  }

  login.register(email.value,password.value,name.value,
  birthDate.value, nif.value?.toString() ?? "", citizenNumber.value, 
  address.value, parseInt(cellNumber.value ?? "000000000"), "apostador")
  .then(success => {
    if (success) router.push({name: "home"});
    else errorFetching.value = true
  });
};
</script>
