FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart pub get --offline
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

WORKDIR /app/build
RUN dart pub get
RUN dart compile exe bin/server.dart -o server

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/build/server /app/server
COPY --from=build /runtime/ /

EXPOSE 8080
CMD ["/app/server"]
