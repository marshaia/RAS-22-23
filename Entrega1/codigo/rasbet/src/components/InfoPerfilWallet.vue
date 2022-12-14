<template>
    <div class="h-full rounded-2xl bg-white dark:bg-black p-2">
        <div class="font-semibold text-2xl text-center text-rasbet-logo-gold border-b-2 border-rasbet-logo-gold pb-2 mb-3">
            Wallet
        </div>

        <div class="flex justify-center items-center mt-10">
            <div class="text-black dark:text-white  font-semibold text-5xl">{{login.user?.carteira}}</div>
            <CurrencyEuroIcon class="ml-5 h-20 text-rasbet-logo-gold"/>
        </div>

        <div class="flex justify-center mt-28">
            <BaseModalPayment button="Deposit" title="Deposit" />
        </div>
    </div>
</template>

<script setup lang="ts">
import {CurrencyEuroIcon} from "@heroicons/vue/24/outline"
import BaseModalPayment from "./BaseModalPayment.vue";
import { loginState } from '../stores/loginStore'

const login = loginState();
</script>