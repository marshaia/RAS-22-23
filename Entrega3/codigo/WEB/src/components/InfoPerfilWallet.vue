<template>
    <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-3 px-8 h-full w-full">
    <div class="flex flex-col h-full">
        <div class="text-xl font-semibold text-rasbet-logo-gold mb-2 pb-2 border-b-2 border-rasbet-logo-gold text-center">
          Carteira
        </div>

        <div class="flex grow justify-center items-center">
            <div class="text-black dark:text-white font-semibold text-5xl">{{login.user?.valorcarteira}}</div>
            <CurrencyEuroIcon class="ml-5 h-20 text-rasbet-logo-gold"/>
        </div>

        <div class="flex flex-col justify-center space-y-3 ">
            <button
              type="button"
              @click="openModalDeposito=true"
              class="rounded-md dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
              Depósito
            </button>

            <button
              type="button"
              @click="openModalLevantamento=true"
              class="rounded-md dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
              Levantamento
            </button>
            <BaseModalPayment title="Depósito" :is-open="openModalDeposito" @close="openModalDeposito=false"/>
            <BaseModalPayment title="Levantamento" :is-open="openModalLevantamento" @close="openModalLevantamento=false" />
        </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { CurrencyEuroIcon } from "@heroicons/vue/24/outline";
import BaseModalPayment from "./BaseModalPayment.vue";
import { loginState } from '../stores/loginStore';
import { ref } from 'vue';

const login = loginState();

const openModalDeposito = ref<boolean>(false);
const openModalLevantamento = ref<boolean>(false);
</script>