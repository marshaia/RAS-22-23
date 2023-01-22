<template>
  <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-3 px-8 h-full w-full">
    <div class="flex flex-col h-full">
        <div class="text-xl font-semibold text-rasbet-logo-gold mb-2 pb-2 border-b-2 border-rasbet-logo-gold text-center">
          Perfil
        </div>

    <div class="mt-5 text-lg space-y-2">
        <!-- Name -->
        <div class="flex">
          <span class="text-rasbet-logo-gold text-md mr-2 ">Nome: </span>
          <span class="text-black dark:text-white text-md">
            {{ login.user?.nome }}
          </span>
        </div>
    
        <!-- Email -->
        <div class="flex">
          <span class="text-rasbet-logo-gold text-md mr-2">Email: </span>
          <span class="text-black dark:text-white text-md">
            {{  login.user?.email }}
          </span>
        </div>
      
        <!-- Birth Date -->
        <div class="flex">
          <span class="text-rasbet-logo-gold text-md mr-2">Data Nascimento: </span>
          <span class="text-black dark:text-white text-md">
            {{  login.user?.datanascimento }}
          </span>          
        </div>
      
        <!-- NIF -->
        <div class="flex">
          <span class="text-rasbet-logo-gold text-md mr-2">NIF: </span>
          <span class="text-black dark:text-white text-md">
            {{  login.user?.nif }}
          </span>          
        </div>

        <!-- CC -->
        <div class="flex ">
          <span class="text-rasbet-logo-gold text-md mr-2">CC: </span>
          <span class="text-black dark:text-white text-md">
            {{  login.user?.cc }}
          </span>
        </div>

        <!-- Cellphone -->
        <div class="flex">
          <span class="text-rasbet-logo-gold text-md mr-2">Telemóvel: </span>
          <span class="text-black dark:text-white text-md">
            {{  login.user?.telefone }}
          </span>
        </div>
              
      <!-- Address -->
      <div class="flex">
        <span class="text-rasbet-logo-gold text-md mr-2">Endereço: </span>
        <span class="text-black dark:text-white text-md">
            {{  login.user?.endereco }}
        </span>
      </div>

    </div>
    <div class="grow"></div>
    <div class="flex justify-center mt-8 justify-">
      <button
        type="button"
        @click="openModalEdit=true"
        class="rounded-md dark:bg-opacity-40 bg-opacity-60 font-semibold uppercase bg-rasbet-logo-gold px-4 py-2 text-sm text-white hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
        Editar
      </button>

      <BaseModalEditProfile :user="login.user" :is-open="openModalEdit" @close="openModalEdit=false" />

      <button
        type="button"
        @click="openModalPass=true"
        class="ml-2 rounded-md dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
        Alterar Password
      </button>

      <BaseModalEditPassword :is-open="openModalPass" @close="openModalPass=false" />
    </div>
  </div>
  </div>
</template>

<script setup lang="ts">
import BaseModalEditProfile from './BaseModalEditProfile.vue';
import BaseModalEditPassword from './BaseModalEditPassword.vue';
import { loginState } from '../stores/loginStore'
import { ref } from 'vue';

const login = loginState();

const openModalEdit = ref<boolean>(false);
const openModalPass = ref<boolean>(false);
</script>
