<template>
    <BaseModal :title="modal.title" :button-name="modal.buttonName">
    <div
      class="flex flex-col px-2 overflow-hidden overflow-y-auto align-middle"
    >
        <!-- Form -->
        <form class="mt-5" @submit.prevent="formSubmit">
            <!-- Name -->
            <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold">
                Name
            </label>
            <input
                type="text"
                :placeholder="name"
                class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                v-model="name"
                required
           />
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

                <!-- Cellphone number -->
                    <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold">
                        Cellphone
                    </label>
                    <input
                        type="text"
                        placeholder="XXX XXX XXX"
                        class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                        v-model="cellNumber"
                        required
                    />

                <div class="mb-2">
                    <button
                        class="mt-5 mb-1.5 block w-full text-center text-white bg-opacity-40 bg-rasbet-logo-gold hover:bg-rasbet-logo-gold px-2 py-1.5 rounded-md"
                    >
                    Save
                    </button>
                </div>
            </form>
            </div>
        </BaseModal>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import BaseModal from './BaseModal.vue'
import { loginState } from '../stores/loginStore'

const login = loginState();

const name = ref(login.user?.name);
const address = ref(login.user?.morada);
const cellNumber = ref(login.user?.nrtelemovel);
const email = ref(login.user?.email);
const password = ref("");
const confPassword = ref("");

const modal = {
    title: 'Edit Profile', 
    buttonName: 'Edit',
}

const formSubmit = () => {
    console.log('changed!')
}
</script>