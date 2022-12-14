<template>
    <BaseModal @closed="step=0" :title="modalTitle" :button-name="button">
        <BaseModalPaymentAmount v-if="step==0" @next="step=1"/>
        <Payment v-else-if="step==1" @back="step=0" @next="step=2" />
        <div v-else class="flex flex-col h-[100px] justify-center text-center dark:text-white text-black">
            {{ (title || 'Payment') }} made successfully!
        </div>
    </BaseModal>
</template>

<script setup lang="ts">
import BaseModal from './BaseModal.vue'
import Payment from './Payment.vue'
import { ref } from 'vue'
import BaseModalPaymentAmount from './BaseModalPaymentAmount.vue'

interface Props {
    title?: string,
    button: string,
}

const props = defineProps<Props>();

const step = ref(0); // 0 - amount, 1 - payment, 2 - confirmed
const modalTitle = ref(props.title + " Method")
</script>