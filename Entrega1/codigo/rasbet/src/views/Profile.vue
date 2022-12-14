<template>
  <div class="flex items-center justify-center space-x-6 p-4">

    <div class="flex flex-col w-2/5 h-full space-y-6">
      <infoProfile />
      <InfoPerfilWallet />
    </div>

    <div class="flex flex-col w-3/5 h-full space-y-6">
      <InfoPerfilHistApostas class="w-full h-1/2" />
      <InfoPerfilHistTransac class="w-full h-1/2" />
    </div>
  </div>
</template>

<script setup lang="ts">
import infoProfile from "../components/InfoPerfil.vue";
import InfoPerfilHistApostas from "../components/InfoPerfilHistApostas.vue";
import InfoPerfilHistTransac from "../components/InfoPerfilHistTransac.vue";
import InfoPerfilWallet from "../components/InfoPerfilWallet.vue";
</script>