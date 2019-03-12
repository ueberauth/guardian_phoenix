defmodule Guardian.Phoenix.TestSupport.TokenModule do
  @moduledoc """
  A simple json encoding of tokens for testing purposes
  """
  @behaviour Guardian.Token

  def token_id do
    send_function_call({__MODULE__, :token_id, []})
    Guardian.UUID.generate()
  end

  def peek(_mod, token) do
    claims =
      token
      |> Base.decode64!()
      |> Jason.decode!()
      |> Map.get("claims")

    %{claims: claims}
  end

  def build_claims(mod, resource, sub, claims, opts) do
    args = [mod, resource, sub, claims, opts]
    send_function_call({__MODULE__, :build_claims, args})
    default_token_type = apply(mod, :default_token_type, [])
    token_type = Keyword.get(opts, :token_type, default_token_type)

    claims =
      claims
      |> Map.put("sub", sub)
      |> Map.put("typ", token_type)

    if Keyword.get(opts, :fail_build_claims) do
      {:error, Keyword.get(opts, :fail_build_claims)}
    else
      {:ok, claims}
    end
  end

  def create_token(mod, claims, opts) do
    send_function_call({__MODULE__, :create_token, [mod, claims, opts]})

    if Keyword.get(opts, :fail_create_token) do
      {:error, Keyword.get(opts, :fail_create_token)}
    else
      token =
        %{"claims" => claims}
        |> Jason.encode!()
        |> Base.url_encode64(padding: true)

      {:ok, token}
    end
  end

  def decode_token(mod, token, opts) do
    send_function_call({__MODULE__, :decode_token, [mod, token, opts]})

    if Keyword.get(opts, :fail_decode_token) do
      {:error, Keyword.get(opts, :fail_decode_token)}
    else
      try do
        claims =
          token
          |> Base.decode64!()
          |> Jason.decode!()
          |> Map.get("claims")

        {:ok, claims}
      rescue
        _ -> {:error, :invalid_token}
      end
    end
  end

  def verify_claims(mod, claims, opts) do
    send_function_call({__MODULE__, :verify_claims, [mod, claims, opts]})

    if Keyword.get(opts, :fail_verify_claims) do
      {:error, Keyword.get(opts, :fail_verify_claims)}
    else
      {:ok, claims}
    end
  end

  def revoke(mod, claims, token, opts) do
    send_function_call({__MODULE__, :revoke, [mod, claims, token, opts]})

    if Keyword.get(opts, :fail_revoke) do
      {:error, Keyword.get(opts, :fail_revoke)}
    else
      {:ok, claims}
    end
  end

  def refresh(mod, old_token, opts) do
    send_function_call({__MODULE__, :refresh, [mod, old_token, opts]})

    if Keyword.get(opts, :fail_refresh) do
      {:error, Keyword.get(opts, :fail_refresh)}
    else
      {:ok, old_claims} = decode_token(mod, old_token, opts)
      resp = {old_token, old_claims}
      {:ok, resp, resp}
    end
  end

  def exchange(mod, old_token, from_type, to_type, opts) do
    send_function_call({__MODULE__, :exchange, [mod, old_token, from_type, to_type, opts]})

    if Keyword.get(opts, :fail_exchange) do
      {:error, Keyword.get(opts, :fail_exchange)}
    else
      {:ok, old_claims} = decode_token(mod, old_token, opts)
      new_c = Map.put(old_claims, "typ", to_type)

      new_t =
        %{"claims" => new_c}
        |> Jason.encode!()
        |> Base.url_encode64(padding: true)

      {:ok, {old_token, old_claims}, {new_t, new_c}}
    end
  end

  defp send_function_call(call) do
    send(self(), call)
  end
end
