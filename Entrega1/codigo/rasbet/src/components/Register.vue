<template>
  <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-2 px-10">
    <div class="flex flex-row">
      <div class="grow">
        <h1 class="text-xl text-rasbet-logo-gold font-semibold mt-4">
          Welcome to RASBET!
        </h1>
        <small class="text-gray-500 dark:text-gray-300"
          >Please enter your personal details</small
        >
      </div>
      <img
        class="mt-1 h-20 w-auto"
        src="../assets/logoBall.png"
        alt="RasBet Logo"
      />
    </div>

    <!-- Form -->
    <form class="mt-5" @submit.prevent="formSubmit">
      <!-- Name and Birth Date -->
      <div class="flex flex-rows space-x-4">
        <div class="w-1/2">
          <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold"
            >Name</label
          >
          <input
            type="text"
            placeholder="Your Name"
            class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
            v-model="name"
            required
          />
        </div>
        <div class="w-1/2">
          <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold"
            >Birth Date</label
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
        placeholder="Enter your email"
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
            >Confirm Password</label
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
        >Address</label
      >
      <input
        type="text"
        placeholder="Enter your address"
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
            >Citizenship Number</label
          >
          <input
            type="text"
            placeholder="XXX XXX XXX"
            class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
            v-model="citizenNumber"
            required
          />
        </div>
        <div class="w-1/2">
          <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold"
            >Cellphone</label
          >
          <input
            type="text"
            placeholder="XXX XXX XXX"
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
          Sign up
        </button>
      </div>
    </form>

    <div class="text-center">
      <span class="text-xs text-gray-500 font-semibold">
        Already have an account?
      </span>
      <router-link to="/login">
        <button class="text-xs font-semibold text-rasbet-logo-gold underline">
          Login
        </button>
      </router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";

const name = ref<string>("");
const address = ref<string>("");
const citizenNumber = ref<string>("");
const cellNumber = ref<string>("");
const email = ref<string>("");
const password = ref<string>("");
const confPassword = ref<string>("");
const birthDate = ref<Date>();
const nif = ref<number>();

const date = new Date();
date.setFullYear(date.getFullYear() - 18);

const minAge = date.toISOString().split("T")[0];

const formSubmit = () => {
  // check the 18+ age pq alguns browsers nao suportam o max e min do input

  console.log("registered!");
};
</script>
