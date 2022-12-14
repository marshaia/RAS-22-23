<template>
    <div>
        <form id="amountForm">
            
                <label class="block text-lg mr-3 mt-1.5 font-semibold text-rasbet-logo-gold">
                    Amount
                </label>
                <input
                    type="text"
                    placeholder="0,00€"
                    class="mb-3 block text-lg w-full rounded-md py-2 px-2 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                    v-model="amount"
                    required
                />
            
                <button 
                form="amountForm"
                @click.prevent="amountSubmit"
                class="w-full mt-8 items-center rounded-md bg-opacity-40 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
                NEXT
            </button>
        </form>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const emit = defineEmits(['next'])
const amount = ref()

const amountSubmit = (e:Event) => {
    e.preventDefault()
    // do something with the amount
    emit('next')
}
</script>