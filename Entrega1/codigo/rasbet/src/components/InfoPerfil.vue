<template>
  <div class="h-full rounded-2xl bg-white dark:bg-black p-2">

    <div class="font-semibold text-2xl text-center text-rasbet-logo-gold border-b-2 border-rasbet-logo-gold pb-2 mb-3">
        Profile
    </div>

    <div class="space-y-2 mt-5 px-6">
      <div class="flex flex-row space-x-10">
        <!-- Name -->
        <div class="flex w-1/2">
          <span class="text-rasbet-logo-gold text-md mr-2 font-semibold">Name: </span>
          <span class="text-black dark:text-white text-md">
            {{ login.user?.name }}
          </span>
        </div>
      
        <!-- Email -->
        <div class="flex w-1/2">
          <span class="text-rasbet-logo-gold text-md mr-2 font-semibold">Email: </span>
          <span class="text-black dark:text-white text-md">
            {{  login.user?.email }}
          </span>
        </div>
      </div>
      
      <div class="flex flex-row  space-x-10">
        <!-- Birth Date -->
        <div class="flex w-1/2">
          <span class="text-rasbet-logo-gold text-md mr-2 font-semibold">Birth Date: </span>
          <span class="text-black dark:text-white text-md">
            {{  login.user?.birthDate }}
          </span>
        </div>
      
        <!-- NIF -->
        <div class="flex w-1/2">
          <span class="text-rasbet-logo-gold text-md mr-2 font-semibold">NIF: </span>
          <span class="text-black dark:text-white text-md">
            {{  login.user?.nif }}
          </span>
        </div>
      </div>

      <div class="flex flex-row  space-x-10">
        <!-- CC -->
        <div class="flex w-1/2">
          <span class="text-rasbet-logo-gold text-md mr-2 font-semibold">CC: </span>
          <span class="text-black dark:text-white text-md">
            {{  login.user?.cc }}
          </span>
        </div>
      
        <!-- Cellphone -->
        <div class="flex w-1/2">
          <span class="text-rasbet-logo-gold text-md mr-2 font-semibold">Cellphone: </span>
          <span class="text-black dark:text-white text-md">
            {{  login.user?.nrtelemovel }}
          </span>
        </div>
      </div>
              
      <!-- Address -->
      <div class="flex">
        <span class="text-rasbet-logo-gold text-md mr-2 font-semibold">Address: </span>
        <span class="text-black dark:text-white text-md">
            {{  login.user?.morada }}
        </span>
      </div>
    </div>
    <div class="flex justify-center mt-28">
      <BaseModalEditProfile :user="login.user" />
    </div>
  </div>
</template>

<script setup lang="ts">
import BaseModalEditProfile from './BaseModalEditProfile.vue';
import { loginState } from '../stores/loginStore'

const login = loginState();
</script>
