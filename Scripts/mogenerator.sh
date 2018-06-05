
echo "Removing old MogeneratorPONSO"
cd "${SRCROOT}/MyEtherWallet-iOS/Classes/Models/GeneratedPONSO/"
rm *.*
echo " "

echo "Renaming old ponso to save custom logic"
cd "${SRCROOT}/MyEtherWallet-iOS/Classes/Models/PlainObjects/"
for file in *.*
do
  filename="${file/PlainObject.*/}"
  ext="${file##*.}"
  mv $file ${filename}ModelObject.${ext}
done
echo " "

echo "Run mogenerator"
/usr/local/bin/mogenerator \
--model "${PROJECT_DIR}/MyEtherWallet-iOS/Classes/Models/CoreDataModel/MEWconnect.xcdatamodeld" \
--machine-dir "${PROJECT_DIR}/MyEtherWallet-iOS/Classes/Models/GeneratedMO/" \
--human-dir "${PROJECT_DIR}/MyEtherWallet-iOS/Classes/Models/ManagedObjects/" \
--template-var arc=true

echo "Generating PONSO"

/usr/local/bin/mogenerator \
--model "${PROJECT_DIR}/MyEtherWallet-iOS/Classes/Models/CoreDataModel/MEWconnect.xcdatamodeld" \
--machine-dir "${PROJECT_DIR}/MyEtherWallet-iOS/Classes/Models/GeneratedPONSO/" \
--human-dir "${PROJECT_DIR}/MyEtherWallet-iOS/Classes/Models/PlainObjects/" \
--template-path "${PROJECT_DIR}/Scripts/PONSOTemplates" \
--base-class "NSObject" \
--template-var arc=true
echo " "

echo "Renaming back old ponso with custom custom logic"
cd "${SRCROOT}/MyEtherWallet-iOS/Classes/Models/GeneratedPONSO/"
for file in *.*
do
  filename="${file/ModelObject.*/}"
  ext="${file##*.}"
  mv $file ${filename}PlainObject.${ext}
done
echo " "

cd "${SRCROOT}/MyEtherWallet-iOS/Classes/Models/PlainObjects/"
for file in *.*
do
  filename="${file/ModelObject.*/}"
  ext="${file##*.}"
  mv $file ${filename}PlainObject.${ext}
done
