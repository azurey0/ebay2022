mkdir data
cd data
wget https://download.geonames.org/export/zip/US.zip
unzip US.zip
wget https://simplemaps.com/static/data/us-zips/1.79/basic/simplemaps_uszips_basicv1.79.zip
unzip simplemaps_uszips_basicv1.79.zip

cd ..
python -m process_data.collect_zipcode
python -m process_data.set_zipcode_info
python -m process_data.parse_train
python -m process_data.split_train
python -m process_data.parse_quiz
python -m process_data.one_hot_encode
python -m process_data.split_train --target parsed_train_cat.tsv --filename=subtrain_cat


python -m model.xgb_train
python -m model.xgb_quiz

python -m model.LightGBM_train
python -m model.LightGBM_quiz

python -m model.cat_train --depth=12 --num_rounds=1000 --esr=3 --border_count=254, --random_strength=1, --l2_leaf=3
python -m model.cat_quiz

