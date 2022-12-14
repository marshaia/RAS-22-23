<template>
  <div class="bg-white dark:bg-rasbet-view-black rounded-2xl">
    <div class="dark:text-gray-400 text-black txt-md ml-5 mt-1">
      Please select your preferred payment method
    </div>

    <div class="flex mt-8 ml-5 items-center justify-center">
      <!--Wallet -->
      <button
        class="mr-5 border-2 border-gray-500 rounded-md bg-white hover:bg-gray-400 focus:bg-gray-400 dark:bg-black dark:hover:bg-rasbet-view-black"
      >
        <WalletIcon class="h-20 text-rasbet-logo-gold" />
    </button>

      <!--Multibanco -->
      <button
        class="mr-5 border-2 border-gray-500 rounded-md bg-white hover:opacity-30 focus:opacity-30 dark:bg-black dark:hover:bg-rasbet-view-black"
      >
        <img class="h-20" src="../assets/multibanco.png" />
      </button>

      <!--MBWay -->
      <button
        class="mr-5 border-2 border-gray-500 rounded-md bg-white hover:bg-gray-400 focus:bg-gray-400 dark:bg-black dark:hover:bg-rasbet-view-black"
      >
        <img class="h-20" src="../assets/vue.svg" />
      </button>
    </div>

    <button 
    @click.prevent="confirmPayment"
    class="w-full mt-8 items-center rounded-md bg-opacity-40 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
      NEXT
    </button>

    <div class="flex justify-center">
      <button
      @click.prevent="$emit('back')" 
      class="text-black dark:text-white text-sm underline hover:text-rasbet-logo-gold text-center mt-5">
      back
    </button>
    </div>

  </div>
</template>

<script setup lang="ts">
import { WalletIcon } from "@heroicons/vue/24/outline";

const emit = defineEmits(['back','next'])

const confirmPayment = () => {
  emit('next')
}
</script>
