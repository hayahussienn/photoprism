# Use multi-stage build for better optimization
FROM photoprism/develop:oracular AS build

WORKDIR "/go/src/github.com/photoprism/photoprism"
COPY . .

# ✅ Use the official build system
RUN sudo make dep
RUN sudo make all install DESTDIR=/opt/photoprism

# ✅ Use a slim production image
FROM photoprism/develop:oracular-slim

# Copy built application from build stage
COPY --from=build --chown=root:root --chmod=755 /opt/photoprism/ /opt/photoprism

# ✅ Set correct environment variables
ENV PHOTOPRISM_HTTP_PORT="9090"
ENV PHOTOPRISM_HTTP_HOST="0.0.0.0"
ENV PHOTOPRISM_DATABASE_DRIVER="sqlite"
ENV PHOTOPRISM_DATABASE_NAME="photoprism"
ENV PHOTOPRISM_STORAGE_PATH="/photoprism/storage"
ENV PHOTOPRISM_ASSETS_PATH="/photoprism/assets"
ENV PHOTOPRISM_PUBLIC="false"
ENV PHOTOPRISM_READONLY="false"
ENV PHOTOPRISM_SITE_URL="http://localhost:9090/"
ENV PHOTOPRISM_UPLOAD_NSFW="true"
ENV PHOTOPRISM_DISABLE_CHOWN="false"
ENV PHOTOPRISM_DISABLE_WEBDAV="false"

# ✅ Set correct permissions
RUN mkdir -p /photoprism/storage \
    && chown -R 1000:1000 /photoprism/storage \
    && chmod -R 755 /photoprism/storage

# ✅ Expose correct ports
EXPOSE 9090

# ✅ Use the official entrypoint script
ENTRYPOINT ["/scripts/entrypoint.sh"]

# ✅ Start PhotoPrism
CMD ["/opt/photoprism/bin/photoprism", "start"]
