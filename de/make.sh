#PATH=$PATH:/opt/homebrew/bin
echo Starting Book Generation ...

# Variables
filename="barcamp-co"
#chapters="./src/index.md"
chapters=$(find ./src -type f -name "[0-9]*.md" | sort | paste -sd ' ' -)
chapters="./src/index.md $chapters"

# Delete Old Versions
echo Deleting old versions ...
rm -rf $filename.*
rm -rf ../docs/de/*
# rm -ff ../docs/de-slides/index.html

# Create Web Version (mkdocs)
echo Creating Web Version ...
mkdocs build

# Create Microsoft Word Version (docx)
echo Creating Word version ...
pandoc metadata.yaml -s --resource-path="./src" -N --toc -V lang=de-de -o $filename.docx $chapters

# Create HTML Version (html)
echo Creating HTML version ...
pandoc metadata.yaml -s --resource-path="./src" -N --toc -V lang=de-de -o $filename.html $chapters

# Create PDF Version (pdf)
echo Creating PDF version ...
pandoc metadata.yaml -s --resource-path="./src" --template lernos -N --toc -V lang=de-de -o $filename.pdf $chapters

# Create eBook Versions (epub)
echo Creating eBook versions ...
magick -density 300 $filename.pdf[0] ebook-cover.jpg
mogrify -size 2500x2500 -resize 2500x2500 ebook-cover.jpg
mogrify -crop 1563x2500+102+0 ebook-cover.jpg
pandoc metadata.yaml -s --resource-path="./src" --epub-cover-image=ebook-cover.jpg -N --toc -V lang=de-de -o $filename.epub $chapters

# Create Markdown Version (md)
echo Creating Markdown version ...
pandoc metadata.yaml -s --resource-path="./src" -N --toc -V lang=de-de -o $filename.md $chapters

# Remove Unnecessary Files
rm ebook-cover.jpg
