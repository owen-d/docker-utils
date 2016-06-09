TAG_PREFIX=${TAG_PREFIX:-}
DOCKERFILE_DIR=${DOCKERFILE_DIR:-.}
DOCKERFILE_LOCATION=$DOCKERFILE_DIR/Dockerfile

# open fd for subrouting stdout to current shell stdout
exec 6>&1
IMAGE_ID=$(docker build $DOCKERFILE_DIR | tee >(cat - >&6) | tail -n 1 | awk '{print $3}')

# close fd
exec 6>&-

echo -e "\n\n\n\n..........\nusing image-id: $IMAGE_ID as tag.\nFull image: $TAG_PREFIX:$IMAGE_ID\n.........."

docker tag $IMAGE_ID $TAG_PREFIX:$IMAGE_ID


# docker push $TAG_PREFIX:$IMAGE_ID
