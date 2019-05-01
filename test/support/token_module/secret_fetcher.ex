defmodule Guardian.Phoenix.TestSupport.TokenModule.SecretFetcher do
  alias Guardian.Token.Jwt.SecretFetcher.SecretFetcherDefaultImpl

  def fetch_signing_secret(mod, opts) do
    if Keyword.has_key?(opts, :fetched_secret) do
      val = Keyword.get(opts, :fetched_secret)
      {:ok, val}
    else
      SecretFetcherDefaultImpl.fetch_signing_secret(mod, opts)
    end
  end

  def fetch_verifying_secret(mod, headers, opts) do
    if Keyword.has_key?(opts, :fetched_secret) do
      val = Keyword.get(opts, :fetched_secret)
      send(self(), {:secret_fetcher, headers})
      {:ok, val}
    else
      SecretFetcherDefaultImpl.fetch_verifying_secret(mod, headers, opts)
    end
  end
end
