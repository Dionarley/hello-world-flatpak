#!/usr/bin/env bash

set -e

# checagens básicas
command -v whiptail >/dev/null || {
  echo "whiptail não instalado"
  exit 1
}

command -v flatpak-builder >/dev/null || {
  echo "flatpak-builder não instalado"
  exit 1
}

# encontrar manifests
MANIFESTS=($(find . -maxdepth 2 -name "*.yml" -o -name "*.yaml"))

if [ ${#MANIFESTS[@]} -eq 0 ]; then
  whiptail --msgbox "Nenhum manifesto Flatpak encontrado (.yml/.yaml)" 10 60
  exit 1
fi

MENU_ITEMS=()
for m in "${MANIFESTS[@]}"; do
  MENU_ITEMS+=("$m" "")
done

MANIFEST=$(whiptail --title "Flatpak Builder" \
  --menu "Selecione o manifesto:" 20 70 10 \
  "${MENU_ITEMS[@]}" \
  3>&1 1>&2 2>&3)

[ -z "$MANIFEST" ] && exit 1

# build dir
BUILDDIR=$(whiptail --inputbox \
  "Informe o diretório de build:" 10 60 "build-dir" \
  3>&1 1>&2 2>&3)

[ -z "$BUILDDIR" ] && exit 1

mkdir -p "$BUILDDIR"

# modo
MODE=$(whiptail --title "Modo de execução" \
  --menu "O que deseja fazer?" 15 60 2 \
  "build" "Apenas construir" \
  "run"   "Construir e executar" \
  3>&1 1>&2 2>&3)

[ -z "$MODE" ] && exit 1

CMD="flatpak-builder"

if [ "$MODE" = "run" ]; then
  CMD="$CMD --run"
fi

CMD="$CMD \"$BUILDDIR\" \"$MANIFEST\""

if [ "$MODE" = "run" ]; then
  APP=$(whiptail --inputbox \
    "Comando dentro do sandbox (/app/bin/...):" \
    10 70 "/app/bin/hello-world" \
    3>&1 1>&2 2>&3)

  [ -z "$APP" ] && exit 1
  CMD="$CMD $APP"
fi

# confirmação
whiptail --yesno "Executar?\n\n$CMD" 15 80 || exit 0

# executar
clear
echo ">> $CMD"
eval $CMD
