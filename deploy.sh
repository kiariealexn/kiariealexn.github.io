#!/bin/bash

set -e  # stop the script immediately if any command fails, instead of continuing on a broken step

# --- Config: fill these in once ---

S3_BUCKET="kiarielabs.com"

DISTRIBUTION_ID="E2JPGWNW3LT96Y"   # replace with your actual CloudFront distribution ID

SITE_DIR="./_site"

echo "==> Building Jekyll site..."

bundle exec jekyll build

echo "==> Syncing to S3 bucket: $S3_BUCKET"

aws s3 sync "$SITE_DIR" "s3://$S3_BUCKET" --delete

echo "==> Invalidating CloudFront cache..."

aws cloudfront create-invalidation --distribution-id E2JPGWNW3LT96Y --paths "/*"

echo "==> Deploy complete. Changes may take a few minutes to fully propagate."
