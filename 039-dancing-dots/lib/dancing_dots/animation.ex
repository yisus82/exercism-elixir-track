defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts) :: {:ok, opts} | {:error, error}
  @callback handle_frame(dot, frame_number, opts) :: dot

  @spec __using__(any) ::
          {:__block__, [],
           [{:@, [...], [...]} | {:def, [...], [...]} | {:defoverridable, [...], [...]}, ...]}
  defmacro __using__(_opts) do
    quote do
      @behaviour DancingDots.Animation
      def init(opts), do: {:ok, opts}
      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation

  @doc """
  In every 4th frame, returns the dot with half of its original opacity.
  In other frames, returns the dot unchanged.
  Frames are counted from 1.
  The `dot` is always the dot in its original state, not in the state from the previous frame.
  """
  @spec handle_frame(
          DancingDots.Animation.dot(),
          DancingDots.Animation.frame_number(),
          DancingDots.Animation.opts()
        ) :: DancingDots.Animation.dot()
  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, _opts) when rem(frame_number, 4) == 0,
    do: %DancingDots.Dot{dot | opacity: dot.opacity / 2}

  def handle_frame(dot, _frame_number, _opts), do: dot
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation

  @doc """
  Validates that `opts` is a keyword list with a `:velocity` key.
  The value of velocity must be a number.
  """
  @spec init(DancingDots.Animation.opts()) ::
          {:ok, DancingDots.Animation.opts()} | {:error, DancingDots.Animation.error()}
  @impl DancingDots.Animation
  def init([velocity: velocity] = opts) when is_number(velocity), do: {:ok, opts}

  def init(opts),
    do:
      {:error,
       "The :velocity option is required, and its value must be a number. Got: #{inspect(opts[:velocity])}"}

  @doc """
    Return the `dot` with its radius increased by the current frame number, minus one, times velocity.
    Frames are counted from 1.
    The `dot` is always the dot in its original state, not in the state from the previous frame.
  """
  @spec handle_frame(
          DancingDots.Animation.dot(),
          DancingDots.Animation.frame_number(),
          DancingDots.Animation.opts()
        ) :: DancingDots.Animation.dot()
  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, [velocity: velocity] = _opts),
    do: %DancingDots.Dot{dot | radius: dot.radius + (frame_number - 1) * velocity}
end
